table 75014 "BA Product Profile"
{
    DataClassification = CustomerContent;
    Caption = 'Product Profile';

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(10; "Item Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Category".Code;
        }
        field(11; "Item Tracking Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Tracking Code".Code;
        }
        field(12; "Gen. Prod. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(13; "Core Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "ENC Core Product";
        }
        field(14; "Core Prod. Sub. Cat. Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Core Prod. Sub. Category Code';
            TableRelation = "ENC Core Product Sub. Category";
        }
        field(15; "Manufacturing Dept."; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Manufacturing Dept.';
            TableRelation = "ENC Department Code".Name where (Type = const (Manufacturing));
            ValidateTableRelation = true;
        }

        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (3), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (4), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (5), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (6), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (7), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (8), Blocked = const (false), "ENC Inactive" = const (false));
        }
        field(58; "Product ID Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID Code';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = CONST ('PRODUCT ID'), Blocked = const (false), "ENC Inactive" = const (false));
        }
    }

    keys
    {
        key(k1; "Product Code")
        {
            Clustered = true;
        }
    }
}