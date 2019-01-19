#pragma once

#include <algorithm>
#include "ClassMacros.h"
#include "CodeContract.h"

namespace tecplot {

/**
 * A simple and fast abstraction over raw arrays to allow for dynamic resizing. The raw array can be
 * stack or heap allocated. If a size request exceeds the initial capacity the array will be
 * reallocated using operator new[] and operator delete[]. Consequently it is important to not
 * exceed the capacity of a stack allocated array. The main responsibility of this class is to
 * maintain a raw array with its capacity and size and if necessary resize the underlying
 * representation. Ownership of the array remains with the client, even if reallocated by this
 * class.
 *
 * The motivation for this class is to provide high performance access to raw arrays that need to be
 * dynamically sized where the performance of std::vector would not suffice because of its
 * requirements to be more general and Tecplot's need to adapt raw arrays for various interfaces in
 * the code base.
 */
template <typename T>
class RawArray
{
public:
    /**
     * Constructs a raw array pointing to NULL. It cannot be resized and is primarily used as a
     * placeholder for later assignment.
     */
    RawArray()
        : m_valuesRef(NULL)
        , m_values(NULL)
        , m_capacity(0)
        , m_size(0)
    {
    }

    /**
     * Creates a simple abstraction over a raw C array such as "int a[5]".
     * @param values
     *     The address of an array of simple types.
     * @param capacity
     *     The capacity of the array.
     * @param size
     *     Current size of the array. If not supplied it is zero.
     */
    RawArray(
        T* const& values,
        size_t    capacity,
        size_t    size = 0)
        : m_valuesRef(NULL)
        , m_values(const_cast<T*>(values))
        , m_capacity(capacity)
        , m_size(size)
    {
        REQUIRE(VALID_REF(this->m_values));
        REQUIRE(m_capacity != 0);
        REQUIRE(this->m_capacity >= this->m_size);
    }

    /**
     * Creates a simple abstraction over a pointer to a raw C array such as "int* a = new int[5]".
     * @param values
     *     The address of an array of simple types.
     * @param capacity
     *     The capacity of the array. If zero the values array must also be NULL.
     * @param size
     *     Current size of the array. If not supplied it is zero.
     */
    RawArray(
        T*&    values,
        size_t capacity = 0,
        size_t size = 0)
        : m_valuesRef(&values)
        , m_values(values)
        , m_capacity(capacity)
        , m_size(size)
    {
        REQUIRE(VALID_REF(this->m_values) || this->m_values == NULL);
        REQUIRE(EQUIVALENCE(this->m_values == NULL, m_capacity == 0));
        REQUIRE(this->m_capacity >= this->m_size);
    }

    /**
     * Resets the object to its default construction that points to NULL and represents a raw array
     * that can no longer be used except as a placeholder for later assignment.
     * @sa the default constructor, RawArray()
     */
    void reset()
    {
        m_valuesRef = NULL;
        m_values = NULL;
        m_capacity = 0;
        m_size = 0;
    }

    /**
     * @return true if the raw array is empty otherwise false
     */
    bool empty() const
    {
        return m_size == 0;
    }

    /**
     * @return current array size
     */
    size_t size() const
    {
        return m_size;
    }

    /**
     * Ensures that the array has sufficient capacity to hold the specified number of items. If the
     * capacity needs to grow to accommodate a larger size it is expanded to exactly the requested
     * number.
     * @param size
     *     Requested capacity.
     * @throws std::bad_alloc
     *     if the capacity needed to be enlarged but sufficient resources were not available
     */
    void reserve(size_t size)
    {
        if (size > m_capacity)
            enlargeCapacity(size);
    }

    /**
     * Sets the size of the array, ensuring there is sufficient capacity.
     * @param size
     *     The new size of the array.
     */
    void setSize(size_t size)
    {
        REQUIRE(size <= m_capacity);
        m_size = size;
        ENSURE(m_size <= m_capacity);
    }

    /**
     * Sets the size of the array to zero (empty)
     */
    void clear()
    {
        m_size = 0;
    }

    /**
     * @return current array capacity
     */
    size_t capacity() const
    {
        return m_capacity;
    }

    /**
     * Copy the size and values from the other raw array to this one.
     * @param other
     *     Other array from which to copy the values.
     * @return
     *     This raw array reference.
     * @throws std::bad_alloc
     *     if the capacity needed to be enlarged but sufficient resources were not available
     */
    RawArray& copy(RawArray const& other)
    {
        reserve(other.m_size);
        setSize(other.m_size);
        for (size_t offset = 0; offset < m_size; ++offset)
            m_values[offset] = other.m_values[offset];
        return *this;
    }

    /**
     * Append the values from the other array to the end of this array.
     * @param other
     *     Other array from which to append the values.
     * @return
     *     This raw array reference.
     * @throws std::bad_alloc
     *     if the capacity needed to be enlarged but sufficient resources were not available
     */
    RawArray& append(RawArray const& other)
    {
        size_t const origSize = m_size;
        reserve(m_size + other.m_size);
        setSize(m_size + other.m_size);
        for (size_t offset = origSize; offset < m_size; ++offset)
            m_values[offset] = other.m_values[offset-origSize];
        return *this;
    }

    /**
     * Append the value to the end of this array.
     * @param Note:
     *     This function is not efficient for appending multiple values if the size bumps into the
     *     capacity because resizes are not padded.
     * @param value
     *     The value to append.
     * @return
     *     This raw array reference.
     * @throws std::bad_alloc
     *     if the capacity needed to be enlarged but sufficient resources were not available
     */
    RawArray& append(T const& value)
    {
        size_t const origSize = m_size;
        reserve(m_size + 1);
        setSize(m_size + 1);
        m_values[origSize] = value;
        return *this;
    }

    /**
     * Copy the values of this array to the target C array. The caller must make sure the target
     * C array has sufficient capacity to receive the values.
     * @param target
     *     The raw array to receive the values and size.
     */
    void copyTo(T* target)
    {
        for (size_t offset = 0; offset < m_size; ++offset)
            target[offset] = m_values[offset];
    }

    /**
     * Access the array item at the specified offset for modification.
     * @note
     *     If you intend to assign many values to the array you should instead get the base address
     *     of the array into a local copy and access the members via the local pointer:
     *         int* localCopy = &myValues[0];
     *         for (i in 1..1000000)
     *             localCopy[i] = ...
     * @return address of the array member at offset
     */
    T& operator[](size_t offset)
    {
        REQUIRE(offset < this->m_size ||
                (offset == 0 && this->m_capacity != 0)); // ...special case to access the array base
        return m_values[offset];
    }

    /**
     * Access the array item at the specified offset for examination.
     * @note
     *     If you intend to read many values from the array you should instead get the base address
     *     of the array into a local copy and access the members via the local pointer:
     *         int* localCopy = &myValues[0];
     *         for (i in 1..1000000)
     *             doSomthing(localCopy[i]);
     * @return constant address of the array member at offset
     */
    T const& operator[](size_t offset) const
    {
        REQUIRE(offset < this->m_size ||
                (offset == 0 && this->m_capacity != 0)); // ...special case to access the array base
        return m_values[offset];
    }

    /**
     * @return true if the raw array is pointing to NULL, false otherwise
     */
    bool isNull() const
    {
        return (m_valuesRef == NULL || *m_valuesRef == NULL);
    }

    typedef T const* const_iterator;
    const_iterator begin() const
    {
        return m_values;
    }
    const_iterator end() const
    {
        return m_values+m_size;
    }

    typedef T* iterator;
    iterator begin()
    {
        return m_values;
    }
    iterator end()
    {
        return m_values+m_size;
    }

private:
    /**
     * Enlarges the array capacity such that it can receive values between 0 and capacity-1. A new
     * array is created using operator new[] into which the new values are copied, after which the
     * original array is deleted using operator delete[]. Consequently it is important, if the
     * capacity is to be enlarged, that the underlying array was allocated with operator new[].
     *
     * @note
     *     This method is only exception safe for array member types who's copy constructors do not
     *     throw.
     *
     * @param capacity
     *     Needed capacity.
     * @throws std::bad_alloc
     *     if sufficient resources were not available to enlarge the capacity
     */
    void enlargeCapacity(size_t capacity)
    {
        REQUIRE(capacity > m_capacity);
        REQUIRE(m_valuesRef != NULL);
        T* values = new T[capacity];
        if (m_size != 0)
            std::copy(m_values, m_values+m_size, values);
        delete [] m_values;
        *m_valuesRef = values;
        m_values     = values;
        m_capacity   = capacity;
    }

    T**    m_valuesRef; // ...allows the class to reallocate
    T*     m_values;    // ...helps the optimizer create high performance access code
    size_t m_capacity;
    size_t m_size;

    /*
     * It is important not to make copies of RawArray because the size, count, and m_values members
     * can change during use.
     */
    UNCOPYABLE_CLASS(RawArray);
};

}
