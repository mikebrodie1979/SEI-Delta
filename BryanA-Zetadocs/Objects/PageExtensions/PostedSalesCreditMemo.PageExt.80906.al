pageextension 80906 "BAZD Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    PromotedActionCategories = 'New,Process,Report,Credit Memo,Cancel,Navigate,Print/Send,Credit Card,Electronic Document,Zetadocs';
    actions
    {
        modify(ZddSend)
        {
            Promoted = true;
            PromotedCategory = Category10;
            PromotedIsBig = true;
        }
        modify(ZddOutbox)
        {
            Promoted = true;
            PromotedCategory = Category10;
            PromotedIsBig = true;
        }
        modify(ZddRules)
        {
            Promoted = true;
            PromotedCategory = Category10;
            PromotedIsBig = true;
        }
    }
}