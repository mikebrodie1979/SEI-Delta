pageextension 80908 "BAZD Service Quote" extends "Service Quote"
{
    PromotedActionCategories = 'New,Process,Report,Zetadocs';
    actions
    {
        modify(ZddSend)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
        modify(ZddOutbox)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
        modify(ZddRules)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
    }
}