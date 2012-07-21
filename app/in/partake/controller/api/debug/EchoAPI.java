package in.partake.controller.api.debug;

import org.codehaus.jackson.node.JsonNodeFactory;
import org.codehaus.jackson.node.ObjectNode;

import in.partake.base.PartakeException;
import in.partake.controller.api.AbstractPartakeAPI;
import in.partake.model.dao.DAOException;
import in.partake.resource.UserErrorCode;
import play.mvc.Result;

public class EchoAPI extends AbstractPartakeAPI {

    public static Result get() throws DAOException, PartakeException {
        return new EchoAPI().execute();
    }

    public static Result post() throws DAOException, PartakeException {
        return new EchoAPI().execute();
    }

    /**
     * data を読んで、それを echo して返す。
     * data があれば 200 を返し、なければ 400 を返す。
     * @return
     */
    @Override
    protected Result doExecute() throws DAOException {
        String data = getParameter("data");
        if (data == null)
            return renderInvalid(UserErrorCode.INVALID_ARGUMENT);

        ObjectNode obj = new ObjectNode(JsonNodeFactory.instance);
        obj.put("data", data);

        return renderOK(obj);
    }
}
