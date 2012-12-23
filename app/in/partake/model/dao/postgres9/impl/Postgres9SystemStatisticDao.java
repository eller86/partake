package in.partake.model.dao.postgres9.impl;

import in.partake.base.TimeUtil;
import in.partake.model.dao.DAOException;
import in.partake.model.dao.DataIterator;
import in.partake.model.dao.MapperDataIterator;
import in.partake.model.dao.PartakeConnection;
import in.partake.model.dao.access.ISystemStatisticAccess;
import in.partake.model.dao.postgres9.Postgres9Connection;
import in.partake.model.dao.postgres9.Postgres9Dao;
import in.partake.model.dao.postgres9.Postgres9Entity;
import in.partake.model.dao.postgres9.Postgres9EntityDao;
import in.partake.model.dao.postgres9.Postgres9EntityDataMapper;
import in.partake.model.dto.SystemStatistic;

import java.util.UUID;

import net.sf.json.JSONObject;

public class Postgres9SystemStatisticDao extends Postgres9Dao implements ISystemStatisticAccess {
    private static final String ENTITY_TABLE_NAME = "SystemStatistics";
    private static final int CURRENT_VERSION = 1;
    private final Postgres9EntityDao entityDao;
    private final SystemStatisticMapper mapper;

    public Postgres9SystemStatisticDao() {
        entityDao = new Postgres9EntityDao(ENTITY_TABLE_NAME);
        mapper = new SystemStatisticMapper();
    }

    @Override
    public void initialize(PartakeConnection con) throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        entityDao.initialize(pcon);
    }

    @Override
    public void truncate(PartakeConnection con) throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        entityDao.truncate(pcon);
    }

    @Override
    public void put(PartakeConnection con, SystemStatistic t)
            throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        Postgres9Entity entity = mapper.unmap(t);

        if (entityDao.exists(pcon, t.getId())) {
            entityDao.update(pcon, entity);
        } else {
            entityDao.insert(pcon, entity);
        }
    }

    @Override
    public SystemStatistic find(PartakeConnection con, UUID key)
            throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        return mapper.map(entityDao.find(pcon, key));
    }

    @Override
    public boolean exists(PartakeConnection con, UUID key) throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        return entityDao.exists(pcon, key);
    }

    @Override
    public void remove(PartakeConnection con, UUID key) throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        entityDao.remove(pcon, key);
    }

    @Override
    public DataIterator<SystemStatistic> getIterator(PartakeConnection con)
            throws DAOException {
        return new MapperDataIterator<Postgres9Entity, SystemStatistic>(mapper, entityDao.getIterator((Postgres9Connection) con));
    }

    @Override
    public int count(PartakeConnection con) throws DAOException {
        Postgres9Connection pcon = (Postgres9Connection) con;
        return entityDao.count(pcon);
    }

    @Override
    public SystemStatistic findLatest(PartakeConnection con)
            throws DAOException {
        SystemStatistic latest = null;

        // TODO bad for performance: iterating all entities to get latest one
        final DataIterator<SystemStatistic> iterator = getIterator(con);
        while (iterator.hasNext()) {
            SystemStatistic next = iterator.next();
            if (latest == null || latest.getDateTime().isBefore(next.getDateTime())) {
                latest = next;
            }
        }
        return latest;
    }

    private static final class SystemStatisticMapper extends Postgres9EntityDataMapper<SystemStatistic> {
        @Override
        public SystemStatistic map(JSONObject obj) {
            return new SystemStatistic(obj).freeze();
        }

        @Override
        public Postgres9Entity unmap(SystemStatistic statistic) {
            return new Postgres9Entity(statistic.getId(), CURRENT_VERSION, statistic.toJSON().toString().getBytes(UTF8), null, TimeUtil.getCurrentDateTime());
        }
    }
}
