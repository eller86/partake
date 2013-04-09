package in.partake.model.dto;

import in.partake.base.DateTime;

import java.util.UUID;

import org.codehaus.jackson.node.JsonNodeFactory;
import org.codehaus.jackson.node.ObjectNode;


public final class SystemStatistic extends PartakeModel<SystemStatistic> {

    private final UUID id;
    private final int totalUser;
    private final int totalEvent;
    private final int publicEvent;
    private final int privateEvent;
    private final int draftEvent;
    private final int publishedEvent;
    private final DateTime dateTime;

    public SystemStatistic(UUID id, int totalUser, int totalEvent,
            int publicEvent, int privateEvent, int draftEvent,
            int publishedEvent, DateTime dateTime) {
        this.id = id;
        this.totalUser = totalUser;
        this.totalEvent = totalEvent;
        this.publicEvent = publicEvent;
        this.privateEvent = privateEvent;
        this.draftEvent = draftEvent;
        this.publishedEvent = publishedEvent;
        this.dateTime = dateTime;
    }

    public SystemStatistic(ObjectNode object) {
        this.id = UUID.fromString(object.get("id").asText());
        this.totalUser = object.get("totalUser").asInt();
        this.totalEvent = object.get("totalEvent").asInt();
        this.publicEvent = object.get("publicEvent").asInt();
        this.privateEvent = object.get("privateEvent").asInt();
        this.draftEvent = object.get("draftEvent").asInt();
        this.publishedEvent = object.get("publishedEvent").asInt();
        this.dateTime = new DateTime(object.get("dateTime").asLong());
    }

    public UUID getId() {
        return id;
    }

    public int getTotalUser() {
        return totalUser;
    }

    public int getTotalEvent() {
        return totalEvent;
    }

    public int getPublicEvent() {
        return publicEvent;
    }

    public int getPrivateEvent() {
        return privateEvent;
    }

    public int getDraftEvent() {
        return draftEvent;
    }

    public int getPublishedEvent() {
        return publishedEvent;
    }

    public DateTime getDateTime() {
        return dateTime;
    }

    @Override
    public Object getPrimaryKey() {
        return id;
    }

    @Override
    public ObjectNode toJSON() {
        ObjectNode object = new ObjectNode(JsonNodeFactory.instance);
        object.put("id", id.toString());
        object.put("totalUser", totalUser);
        object.put("totalEvent", totalEvent);
        object.put("publicEvent", publicEvent);
        object.put("privateEvent", privateEvent);
        object.put("draftEvent", draftEvent);
        object.put("publishedEvent", publishedEvent);
        object.put("dateTime", dateTime.getTime());
        return object;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((dateTime == null) ? 0 : dateTime.hashCode());
        result = prime * result + draftEvent;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + privateEvent;
        result = prime * result + publicEvent;
        result = prime * result + publishedEvent;
        result = prime * result + totalEvent;
        result = prime * result + totalUser;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        SystemStatistic other = (SystemStatistic) obj;
        if (dateTime == null) {
            if (other.dateTime != null)
                return false;
        } else if (!dateTime.equals(other.dateTime))
            return false;
        if (draftEvent != other.draftEvent)
            return false;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (privateEvent != other.privateEvent)
            return false;
        if (publicEvent != other.publicEvent)
            return false;
        if (publishedEvent != other.publishedEvent)
            return false;
        if (totalEvent != other.totalEvent)
            return false;
        if (totalUser != other.totalUser)
            return false;
        return true;
    }
}
