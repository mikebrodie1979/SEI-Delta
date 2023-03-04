report 50087 "BA Set Prod. Creation Fields"
{
    Caption = 'Set Production Creation Fields';
    ApplicationArea = all;
    UsageCategory = Tasks;
    ProcessingOnly = true;


    dataset
    {
        dataitem("Production BOM Version"; "Production BOM Version")
        {
            trigger OnPreDataItem()
            begin
                i := 1;
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                Window.Update(1, StrSubstNo('%1 of %2', i, c1));
                "BA Created By" := 'SYSTEM';
                Modify(false);
            end;
        }
        dataitem("Production BOM Header"; "Production BOM Header")
        {
            trigger OnPreDataItem()
            begin
                i := 1;
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                Window.Update(2, StrSubstNo('%1 of %2', i, c2));
                "BA Created By" := 'SYSTEM';
                Modify(false);
            end;
        }

        dataitem("Production Order"; "Production Order")
        {
            trigger OnPreDataItem()
            begin
                i := 1;
            end;

            trigger OnAfterGetRecord()
            begin
                i += 1;
                Window.Update(3, StrSubstNo('%1 of %2', i, c3));
                "BA Created By" := 'SYSTEM';
                Modify(false);
            end;
        }
    }

    trigger OnPreReport()
    begin
        Window.Open('#1##\#2##\#3##');
        "Production BOM Version".SetRange("BA Created By", '');
        "Production BOM Header".SetRange("BA Created By", '');
        "Production Order".SetRange("BA Created By", '');

        c1 := "Production BOM Version".Count();
        c2 := "Production BOM Header".Count();
        c3 := "Production Order".Count();
        Window.Update(1, StrSubstNo('%1 of %2', i, c1));
        Window.Update(2, StrSubstNo('%1 of %2', i, c2));
        Window.Update(3, StrSubstNo('%1 of %2', i, c3));
    end;

    trigger OnPostReport()
    begin
        Window.Close();
    end;

    var
        Window: Dialog;
        i: Integer;
        c1: Integer;
        c2: Integer;
        c3: Integer;
}