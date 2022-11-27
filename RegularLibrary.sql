-- Включаем CLR

exec sp_configure 'show advanced options', 1;
reconfigure;
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0;
reconfigure;

-- Проверка всех сборок

select * from sys.assemblies

-- Создание сборки RegularLibrary

create assembly RegularLibrary
from 'C:\Users\Илья\Desktop\sp\RegularLibrary\bin\Debug\net472\RegularLibrary.dll'
with permission_set = unsafe;

-- Обновление сборки RegularLibrary

alter assembly RegularLibrary from 'C:\Users\Илья\Desktop\sp\RegularLibrary\bin\Debug\net472\RegularLibrary.dll'

-- Функция SqlRegularExpression (создание и проверка)

create function SqlRegularExpression(@_pattern nvarchar(4000), @_text nvarchar(4000))
returns nvarchar(4000)
as external name RegularLibrary.[RegularLibrary.Regular_fn].SqlRegularExpression

select dbo.SqlRegularExpression('\d{3}','999')

-- Функция SqlRegularReplace (создание и проверка)

create function SqlRegularReplace(@_text nvarchar(4000), @_pattern nvarchar(4000), @_replacement nvarchar(4000))
returns nvarchar(4000)
as external name RegularLibrary.[RegularLibrary.Regular_fn].SqlRegularReplace

select dbo.SqlRegularReplace('привет мир 222722','\d{3}','1')