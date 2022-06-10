tableextension 80031 "BA Vendor" extends Vendor
{
    fields
    {
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Country/Region Code"));
        }
    }
}