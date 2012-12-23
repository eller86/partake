package in.partake.model.dao.access;

import in.partake.model.dao.DAOException;
import in.partake.model.dao.PartakeConnection;
import in.partake.model.dto.SystemStatistic;

import java.util.UUID;

public interface ISystemStatisticAccess extends IAccess<SystemStatistic, UUID> {
    SystemStatistic findLatest(PartakeConnection con) throws DAOException;
}
