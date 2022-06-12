tableextension 80025 "BA Service Header" extends "Service Header"
{
    fields
    {
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field (County));
        }
        modify("Bill-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Bill-to Country/Region Code"));
        }
        modify("Ship-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Ship-to Country/Region Code"));
        }
    }
}