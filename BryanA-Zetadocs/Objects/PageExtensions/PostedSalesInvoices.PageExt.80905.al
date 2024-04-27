pageextension 80905 "BAZD Posted Sales Invoices" extends "Posted Sales Invoices"
{
    PromotedActionCategories = 'New,Process,Report,Invoice,Navigate,Correct,Print/Send,Zetadocs';
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