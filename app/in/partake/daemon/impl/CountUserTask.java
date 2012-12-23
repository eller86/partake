package in.partake.daemon.impl;


import java.util.UUID;

import in.partake.base.DateTime;
import in.partake.base.PartakeException;
import in.partake.base.TimeUtil;
import in.partake.controller.action.admin.AdminCountAccess;
import in.partake.daemon.IPartakeDaemonTask;
import in.partake.model.IPartakeDAOs;
import in.partake.model.access.Transaction;
import in.partake.model.dao.DAOException;
import in.partake.model.dao.PartakeConnection;
import in.partake.model.dao.access.ISystemStatisticAccess;
import in.partake.model.dto.SystemStatistic;

public final class CountUserTask extends Transaction<Void> implements
        IPartakeDaemonTask {
    private DateTime lastUpdated;

    @Override
    public String getName() {
        return "CountUserTask";
    }

    @Override
    public void run() throws Exception {
        this.execute();
    }

    @Override
    protected Void doExecute(PartakeConnection con, IPartakeDAOs daos)
            throws DAOException, PartakeException {
        if (lastUpdated == null) {
            lastUpdated = loadLastUpdatedTime(con, daos);
        }

        DateTime justNow = TimeUtil.getCurrentDateTime();
        if (lastUpdated == null || lastUpdated.isBefore(justNow.nDayBefore(1))) {
            countUser(con, daos);
            lastUpdated = justNow;
        }
        return null;
    }

    private void countUser(PartakeConnection con, IPartakeDAOs daos) throws DAOException, PartakeException {
        AdminCountAccess counter = new AdminCountAccess();
        counter.doExecute(con, daos);

        SystemStatistic statistic = new SystemStatistic(UUID.randomUUID(),
                counter.getCountUser(),
                counter.getCountEvent(),
                counter.getCountPublicEvent(),
                counter.getCountPrivateEvent(),
                counter.getCountDraftEvent(),
                counter.getCountPublishedEvent(),
                TimeUtil.getCurrentDateTime());
        ISystemStatisticAccess access = daos.getSystemStatisticAccess();
        access.put(con, statistic);
    }

    private DateTime loadLastUpdatedTime(PartakeConnection con, IPartakeDAOs daos) throws DAOException {
        ISystemStatisticAccess access = daos.getSystemStatisticAccess();
        SystemStatistic latest = access.findLatest(con);
        DateTime lastUpdatedTime = null;
        if (latest != null) {
            lastUpdatedTime = latest.getDateTime();
        }
        return lastUpdatedTime;
    }

}
