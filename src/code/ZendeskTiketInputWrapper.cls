/**
 * @description       : Zendesk Ticket Wrapper Body.
 * @author            : Mohammad Umar
 * @group             : 
 * @last modified on  : 01/04/2026
 * @last modified by  : madhost
**/
public with sharing class ZendeskTiketInputWrapper {
    
    public ticket ticket;

	public class ticket {
		public String subject;
		public String priority;
		public String type;
		public comment comment;
		public String assignee_id;
		public requester requester;
	}
	public class comment {
		public String body;
	}

	public class requester {
		public Integer locale_id;
		public String name;
		public String email;
	}
}