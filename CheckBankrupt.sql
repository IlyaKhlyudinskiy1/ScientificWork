-- Âêëþ÷àåì CLR

exec sp_configure 'show advanced options', 1;
reconfigure;
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0;
reconfigure;

-- Ïðîâåðêà âñåõ ñáîðîê

select * from sys.assemblies

-- Ñîçäàíèå ñáîðêè CheckBankruptLibrary

create assembly CheckBankruptLibrary
from 'C:\Users\Èëüÿ\Desktop\sp\CheckBankruptLibrary\bin\Debug\net472\CheckBankruptLibrary.dll'
with permission_set = unsafe;

-- Îáíîâëåíèå ñáîðêè CheckBankruptLibrary

alter assembly CheckBankruptLibrary from 'C:\Users\Èëüÿ\Desktop\sp\CheckBankruptLibrary\bin\Debug\net472\CheckBankruptLibrary.dll'

-- Ôóíêöèÿ CheckBankruptByINN (ñîçäàíèå è ïðîâåðêà)

create function CheckBankruptByINN(@_inn nvarchar(4000))
returns nvarchar(4000)
as external name CheckBankruptLibrary.[CheckBankruptLibrary.CheckBankrupt_fn].CheckBankruptByINN

print dbo.CheckBankruptByINN('027201944340')
