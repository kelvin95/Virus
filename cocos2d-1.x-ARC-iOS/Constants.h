
#ifndef Virus_Constants_h
#define Virus_Constants_h

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define TRANSFER_CHARACTERISTIC_UUID    @"EB6727C4-F184-497A-A656-76B0CDAC633A"
#define TRANSFER_SERVICE_UUID           @"FB694B90-F49E-4597-8306-171BBA78F846"
#define NOTIFY_MTU 20

#define kENERGY_UPGRADE 123
#define kLONGEVITY_UPGRADE 124

typedef enum
{
    kCircleGeneral = 11,
    kCircleGreen,
    kCircleRed,
    kCircleWhite,
} CircleType;

typedef enum
{
    kVirusDirectionTop = 0,
    kVirusDirectionTopLeft,
    kVirusDirectionTopRight,
    kVirusDirectionBotLeft,
    kVirusDirectionBotRight,
    kVirusDirectionBot,
} VirusDirection;

#endif