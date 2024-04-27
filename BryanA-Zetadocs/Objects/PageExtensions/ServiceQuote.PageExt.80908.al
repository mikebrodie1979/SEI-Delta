// pageextension 80908 "BAZD Service Quote" extends "Service Quote"
// {
//     PromotedActionCategories = 'New,Process,Report,Quote,View,Approve,Request Approval,History,Print/Send,Release,Navigate,Zetadocs';
//     actions
//     {
//         modify(ZddSend)
//         {
//             Promoted = true;
//             PromotedCategory = Category12;
//             PromotedIsBig = true;
//         }
//         modify(ZddOutbox)
//         {
//             Promoted = true;
//             PromotedCategory = Category12;
//             PromotedIsBig = true;
//         }
//         modify(ZddRules)
//         {
//             Promoted = true;
//             PromotedCategory = Category12;
//             PromotedIsBig = true;
//         }
//     }
// }