// pageextension 80903 "BAZD Sales Orders" extends "Sales Order List"
// {
//     PromotedActionCategories = 'New,Process,Report,Request Approval,Order,Release,Posting,Print/Send,Navigate,Zetadocs';
//     actions
//     {
//         modify(ZddSend)
//         {
//             Promoted = true;
//             PromotedCategory = Category10;
//             PromotedIsBig = true;
//         }
//         modify(ZddOutbox)
//         {
//             Promoted = true;
//             PromotedCategory = Category10;
//             PromotedIsBig = true;
//         }
//         modify(ZddRules)
//         {
//             Promoted = true;
//             PromotedCategory = Category10;
//             PromotedIsBig = true;
//         }
//     }
// }