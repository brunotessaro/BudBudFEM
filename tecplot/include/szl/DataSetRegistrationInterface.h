#pragma once

#include "tpsdkbase_Exports.h"

namespace tecplot { namespace szl {

class tpsdkbase_API DataSetRegistrationInterface
{
public:
    /**
     * Registers SZLOD cell and node connectivity query services with Tecplot for a single FE zone.
     * @param cellConnectivityQuery
     *     SZLOD cell connectivity query service responsible for loading the requested information
     *     for specified subzones. See CellConnectivityQueryInterface's setup(), teardown(), and
     *     destroy() methods for life cycle details.
     * @param nodeConnectivityQuery
     *     SZLOD node connectivity query service responsible for loading the requested information
     *     for specified subzones. See NodeConnectivityQueryInterface's setup(), teardown(), and
     *     destroy() methods for life cycle details.
     * @param zone
     *     Tecplot zone for which the SZLOD cell and node connectivity query services are
     *     registered.
     * @throws std::bad_alloc if sufficient memory is not available
     */
    virtual void registerZoneConnectivityQueryServices(
        class CellConnectivityQueryInterface* cellConnectivityQuery,
        class NodeConnectivityQueryInterface* nodeConnectivityQuery,
        EntIndex_t                            zone) = 0;

    /**
     * Registers SZLOD cell and node connectivity query services with Tecplot for a single ordered
     * zone.
     * @param cellConnectivityQuery
     *     SZLOD cell connectivity query service responsible for loading the requested information
     *     for specified subzones. See CellConnectivityQueryInterface's setup(), teardown(), and
     *     destroy() methods for life cycle details.
     * @param nodeConnectivityQuery
     *     SZLOD node connectivity query service responsible for loading the requested information
     *     for specified subzones. See NodeConnectivityQueryInterface's setup(), teardown(), and
     *     destroy() methods for life cycle details.
     * @param subzoneQuery
     *     SZLOD zone query service responsible for reporting the query results or throwing an
     *     appropriate exception as documented.
     * @param zone
     *     Tecplot zone for which the SZLOD cell and node connectivity query service is registered.
     * @throws std::bad_alloc if sufficient memory is not available
     */
    virtual void registerZoneConnectivityQueryServices(
        class CellConnectivityQueryInterface* cellConnectivityQuery,
        class NodeConnectivityQueryInterface* nodeConnectivityQuery,
        class OrderedSubzoneQueryInterface*   subzoneQuery,
        EntIndex_t                            zone) = 0;

    /**
     * Registers SZLOD zone query services with Tecplot that take one or more variable IDs for the
     * queries. Every Sizzle zone, regardless of connectivity or variable sharing must have its own
     * unique zone query service.
     * @param zoneVarIDQuery
     *     Query service responsible for zone queries with variable IDs.
     * @param zone
     *     Tecplot zone for which the SZLOD query service is registered.
     * @throws std::bad_alloc if sufficient memory is not available
     */
    virtual void registerZoneVarIDQueryServices(
        class ZoneVarIDQueryInterface* zoneVarIDQuery,
        EntIndex_t                     zone) = 0;

    /**
     * Registers SZLOD cell centered and nodal variable value query services and subzone query with
     * Tecplot for a single zone's variable.
     * @param cellCenteredVarQuery
     *     SZLOD cell centered variable data query service responsible for loading the requested
     *     information for specified subzones. See VarValueQueryInterface's setup(), teardown(), and
     *     destroy() methods for life cycle details.
     * @param nodalVarQuery
     *     SZLOD nodal variable data query service responsible for loading the requested information
     *     for specified subzones. See VarValueQueryInterface's setup(), teardown(), and destroy()
     *     methods for life cycle details.
     * @param varSubzoneQuery
     *     SZLOD query service responsible for performing various queries for the zone's variable.
     *     See VarQueryInterface's setup(), teardown(), and destroy() methods for life cycle
     *     details.
     * @param zone
     *     Tecplot zone for which the SZLOD variable value and subzone query services are
     *     registered.
     * @param var
     *     Tecplot variable for which the SZLOD variable value and subzone query services are
     *     registered.
     * @throws std::bad_alloc if sufficient memory is not available
     */
    virtual void registerVarQueryServices(
        class VarValueQueryInterface*   cellCenteredVarQuery,
        class VarValueQueryInterface*   nodalVarQuery,
        class VarSubzoneQueryInterface* varSubzoneQuery,
        EntIndex_t                      zone,
        EntIndex_t                      var) = 0;

    virtual ~DataSetRegistrationInterface() {} // interfaces need an empty virtual destructor, see coding rules
};

}}
