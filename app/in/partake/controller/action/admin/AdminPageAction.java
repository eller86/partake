package in.partake.controller.action.admin;

import java.util.Map;

import in.partake.base.PartakeException;
import in.partake.controller.action.AbstractPartakeAction;
import in.partake.model.dao.DAOException;
import play.mvc.Result;

public class AdminPageAction extends AbstractPartakeAction {
    public static Result get() throws DAOException, PartakeException {
        return new AdminPageAction().execute();
    }

    public Result doExecute() throws DAOException, PartakeException {
        ensureAdmin();

        AdminCountAccess transaction = new AdminCountAccess();
        transaction.execute();

        int countUser = transaction.getCountUser();
        int countEvent = transaction.getCountEvent();
        int countPublicEvent = transaction.getCountPublicEvent();
        int countPrivateEvent = transaction.getCountPrivateEvent();
        int countDraftEvent = transaction.getCountDraftEvent();
        int countPublishedEvent = transaction.getCountPublishedEvent();

        Map<String, String> configurationMap = transaction.getConfigurationMap();

        return render(views.html.admin.index.render(context(), configurationMap, countUser, countEvent, countPublicEvent, countPrivateEvent, countPublishedEvent, countDraftEvent));
    }
}
