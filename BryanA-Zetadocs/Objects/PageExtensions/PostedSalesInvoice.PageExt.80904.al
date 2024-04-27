pageextension 80904 "BAZD Posted Sales Invoice" extends "Posted Sales Invoice"
{
    PromotedActionCategories = 'New,Process,Report,Invoice,Correct,Print/Send,Navigate,Electronic Document,Zetadocs';
    actions
    {
        modify(ZddSend)
        {
            Promoted = true;
            PromotedCategory = Category9;
            PromotedIsBig = true;
        }
        modify(ZddOutbox)
        {
            Promoted = true;
            PromotedCategory = Category9;
            PromotedIsBig = true;
        }
        modify(ZddRules)
        {
            Promoted = true;
            PromotedCategory = Category9;
            PromotedIsBig = true;
        }
    }
}