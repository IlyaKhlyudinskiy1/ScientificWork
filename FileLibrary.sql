-- �������� CLR

exec sp_configure 'show advanced options', 1;
reconfigure;
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0;
reconfigure;

-- �������� ���� ������

select * from sys.assemblies

-- �������� ������ FileLibrary

create assembly FileLibrary
from 'C:\Users\����\Desktop\sp\FileLibrary\bin\Debug\net472\FileLibrary.dll'
with permission_set = unsafe;

-- ���������� ������ FileLibrary

alter assembly FileLibrary from 'C:\Users\����\Desktop\sp\FileLibrary\bin\Debug\net472\FileLibrary.dll'

-- ������� SqlCreateFile (�������� � ��������)

create function SqlCreateFile(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlCreateFile

select dbo.SqlCreateFile('C:\test1\text5.txt')

-- ������� SqlDeleteFile (�������� � ��������)

create function SqlDeleteFile(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlDeleteFile

select dbo.SqlDeleteFile('C:\test1\text2.txt')

-- ������� SqlCopyFile (�������� � ��������)

create function SqlCopyFile(@_firstPath nvarchar(4000), @_secondPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlCopyFile

select dbo.SqlCopyFile('C:\test1\text2.txt', 'C:\test1\test3.werw')

-- ������� SqlMoveFile (�������� � ��������)

create function SqlMoveFile(@_firstPath nvarchar(4000), @_secondPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlMoveFile

select dbo.SqlMoveFile('C:\test1\test.txt', 'C:\test2\test.txt')

-- ������� SqlGetLastAccessTime (�������� � ��������)

create function SqlGetLastAccessTime(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlGetLastAccessTime

select dbo.SqlGetLastAccessTime('C:\test1\test.txt')

-- ������� SqlReplaceFile (�������� � ��������)

create function SqlReplaceFile(@_sourcePath nvarchar(4000), @_destinationPath nvarchar(4000), @_destinationBackupPath nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlReplaceFile

select dbo.SqlReplaceFile('C:\test1\aaa1.txt','C:\test1\aaa2.txt','C:\test1\copy.txt')

-- ������� SqlExistsFile (�������� � ��������)

create function SqlExistsFile(@_path nvarchar(4000))
returns tinyint
as external name FileLibrary.[FileLibrary.File_fn].SqlExistsFile

select dbo.SqlExistsFile('C:\test1\aaa2.txt')

-- ������� SqlReadFile (�������� � ��������)

create function SqlReadFile(@_path nvarchar(4000))
returns varbinary(max)
as external name FileLibrary.[FileLibrary.File_fn].SqlReadFile

print dbo.UTF8_TO_NVARCHAR(convert(varchar(max),dbo.SqlReadFile('C:\test1\aaa2.txt')))

-- ������� SqlGetAttributies (�������� � ��������)

create function SqlGetAttributies(@_path nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlGetAttributies

select dbo.SqlGetAttributies('C:\test1\aaa2.txt')

-- ������� SqlWriteText (�������� � ��������)

create function SqlWriteText(@_path nvarchar(4000), @_text nvarchar(4000))
returns nvarchar(4000)
as external name FileLibrary.[FileLibrary.File_fn].SqlWriteText

select dbo.SqlWriteText('C:\test1\aaa2.txt', 'hello world!!! 
my name is Ilya')

-- �������� ������� ��� �������������� UTF8 � NVARCHAR
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
