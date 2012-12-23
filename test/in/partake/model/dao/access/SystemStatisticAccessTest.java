package in.partake.model.dao.access;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.junit.Assert.assertThat;

import java.util.UUID;

import org.junit.Before;
import org.junit.Test;

import in.partake.app.PartakeApp;
import in.partake.base.DateTime;
import in.partake.base.PartakeException;
import in.partake.base.TimeUtil;
import in.partake.model.IPartakeDAOs;
import in.partake.model.access.DBAccess;
import in.partake.model.dao.DAOException;
import in.partake.model.dao.PartakeConnection;
import in.partake.model.dto.SystemStatistic;

public class SystemStatisticAccessTest extends
        AbstractDaoTestCaseBase<ISystemStatisticAccess, SystemStatistic, UUID> {

    @Override
    @Before
    public void setup() throws Exception {
        super.setup(PartakeApp.getDBService().getDAOs().getSystemStatisticAccess());
    }

    @Override
    protected SystemStatistic create(long pkNumber, String pkSalt, int objNumber) {
        return new SystemStatistic(new UUID(pkNumber, pkSalt.hashCode()),
                0, 0, 0, 0, 0, 0, new DateTime(objNumber));
    }

    @Test
    public void testFindLatest() throws Exception {
        new DBAccess<Void>() {
            @Override
            protected Void doExecute(PartakeConnection con, IPartakeDAOs daos) throws DAOException, PartakeException {
                ISystemStatisticAccess access = daos.getSystemStatisticAccess();
                assertThat(access.findLatest(con), is(nullValue()));

                SystemStatistic oldest = createData(TimeUtil.create(2000, 1, 1, 1, 1, 1));
                access.put(con, oldest);
                assertThat(access.findLatest(con), is(oldest));

                SystemStatistic newest = createData(TimeUtil.create(2010, 1, 1, 1, 1, 1));
                access.put(con, newest);
                assertThat(access.findLatest(con), is(newest));

                SystemStatistic old = createData(TimeUtil.create(2005, 1, 1, 1, 1, 1));
                access.put(con, old);
                assertThat(access.findLatest(con), is(newest));

                return null;
            }

            private SystemStatistic createData(DateTime dateTime) {
                return new SystemStatistic(UUID.randomUUID(), 0, 0, 0, 0, 0, 0, dateTime);
            }
        }.execute();
    }
}
