// pageextension 80911 "BAZD Service Order" extends "Service Order"
// {
//     PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate,Zetadocs';
//     actions
//     {
//         modify(ZddSend)
//         {
//             Promoted = true;
//             PromotedCategory = Category13;
//             PromotedIsBig = true;
//         }
//         modify(ZddOutbox)
//         {
//             Promoted = true;
//             PromotedCategory = Category13;
//             PromotedIsBig = true;
//         }
//         modify(ZddRules)
//         {
//             Promoted = true;
//             PromotedCategory = Category13;
//             PromotedIsBig = true;
//         }
//     }
// }