-- Включаем CLR

exec sp_configure 'show advanced options', 1;
reconfigure;
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0;
reconfigure;

-- Проверка всех сборок

select * from sys.assemblies

-- Создание сборки FileLibrary

create assembly FileLibrary
from 'C:\Users\Илья\Desktop\sp\FileLibrary\bin\Debug\net472\FileLibrary.dll'
with permission_set = unsafe;

-- Обновление сборки FileLibrary

alter assembly FileLibrary from 'C:\Users\Илья\Desktop\sp\FileLibrary\bin\Debug\net472\FileLibrary.dll'

-- Функция SqlCreateFile (создание и проверка)

create function SqlCreateFile(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlCreateFile

select dbo.SqlCreateFile('C:\test1\text5.txt')

-- Функция SqlDeleteFile (создание и проверка)

create function SqlDeleteFile(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlDeleteFile

select dbo.SqlDeleteFile('C:\test1\text2.txt')

-- Функция SqlCopyFile (создание и проверка)

create function SqlCopyFile(@_firstPath nvarchar(4000), @_secondPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlCopyFile

select dbo.SqlCopyFile('C:\test1\text2.txt', 'C:\test1\test3.werw')

-- Функция SqlMoveFile (создание и проверка)

create function SqlMoveFile(@_firstPath nvarchar(4000), @_secondPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlMoveFile

select dbo.SqlMoveFile('C:\test1\test.txt', 'C:\test2\test.txt')

-- Функция SqlGetLastAccessTime (создание и проверка)

create function SqlGetLastAccessTime(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlGetLastAccessTime

select dbo.SqlGetLastAccessTime('C:\test1\test.txt')

-- Функция SqlReplaceFile (создание и проверка)

create function SqlReplaceFile(@_sourcePath nvarchar(4000), @_destinationPath nvarchar(4000), @_destinationBackupPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlReplaceFile

select dbo.SqlReplaceFile('C:\test1\aaa1.txt','C:\test1\aaa2.txt','C:\test1\copy.txt')

-- Функция SqlExistsFile (создание и проверка)

create function SqlExistsFile(@_path nvarchar(4000))
returns tinyint
as external name FileLibrary.[FileLibrary.File_fn].SqlExistsFile

select dbo.SqlExistsFile('C:\test1\aaa2.txt')

-- Функция SqlReadFile (создание и проверка)

create function SqlReadFile(@_path nvarchar(4000))
returns varbinary(max)
as external name FileLibrary.[FileLibrary.File_fn].SqlReadFile

print dbo.UTF8_TO_NVARCHAR(convert(varchar(max),dbo.SqlReadFile('C:\test1\aaa2.txt')))

-- Функция SqlGetAttributies (создание и проверка)

create function SqlGetAttributies(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlGetAttributies

select dbo.SqlGetAttributies('C:\test1\aaa2.txt')

-- Функция SqlWriteText (создание и проверка)

create function SqlWriteText(@_path nvarchar(4000), @_text nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlWriteText

select dbo.SqlWriteText('C:\test1\aaa2.txt', 'hello world!!! 
my name is Ilya')

-- Создание функции для преобразования UTF8 в NVARCHAR
create function dbo.UTF8_TO_NVARCHAR(@in varchar(MAX))
   returns nvarchar(MAX)
as
begin
   declare @out nvarchar(MAX), @i int, @c int, @c2 int, @c3 int, @nc int

   select @i = 1, @out = ''

   while (@i <= Len(@in))
   begin
      set @c = Ascii(SubString(@in, @i, 1))

      if (@c < 128)
      begin
         set @nc = @c
         set @i = @i + 1
      end
      else if (@c > 191 AND @c < 224)
      begin
         set @c2 = Ascii(SubString(@in, @i + 1, 1))

         set @nc = (((@c & 31) * 64 /* << 6 */) | (@c2 & 63))
         set @i = @i + 2
      end
      else
      begin
         set @c2 = Ascii(SubString(@in, @i + 1, 1))
         set @c3 = Ascii(SubString(@in, @i + 2, 1))

         set @nc = (((@c & 15) * 4096 /* << 12 */) | ((@c2 & 63) * 64 /* << 6 */) | (@c3 & 63))
         set @i = @i + 3
      end

      set @out = @out + nchar(@nc)
   end
   return @out
end
go
