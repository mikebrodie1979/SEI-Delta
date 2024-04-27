pageextension 80907 "BAZD Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    PromotedActionCategories = 'New,Process,Report,Credit Memo,Cancel,Navigate,Print/Send,Zetadocs';
    actions
    {
        modify(ZddSend)
        {
            Promoted = true;
            PromotedCategory = Category8;
            PromotedIsBig = true;
        }
        modify(ZddOutbox)
        {
            Promoted = true;
            PromotedCategory = Category8;
            PromotedIsBig = true;
        }
        modify(ZddRules)
        {
            Promoted = true;
            PromotedCategory = Category8;
            PromotedIsBig = true;
        }
    }
}