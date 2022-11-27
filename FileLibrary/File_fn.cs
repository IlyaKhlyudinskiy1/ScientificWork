using System;
using System.IO;
using System.Text;

namespace FileLibrary
{
    public class File_fn
    {
        //Функция для создания файла
        public static string SqlCreateFile(string _path)
        {
            string _resultString;

            if (File.Exists(_path) == false)
            {
                try
                {
                    FileStream _createFile = File.Create(_path);
                    _resultString = "Success";
                    _createFile.Close();
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message;
                }
            }
            else
            {
                _resultString = "File with this name already exists";
            }

            return _resultString;
        }

        //Функция для удаления файла
        public static string SqlDeleteFile(string _path)
        {
            string _resultString;

            if (File.Exists(_path) == true)
            {
                try
                {
                    File.Delete(_path);
                    _resultString = "Success";
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message;
                }
            }
            else
            {
                _resultString = "The file doesn't exist or you don't have access to it";
            }

            return _resultString;
        }

        //Функция для копирования файла
        public static string SqlCopyFile(string _firstPath, string _secondPath)
        {

            string _resultString;

            if (File.Exists(_firstPath) == true)
            {
                try
                {
                    File.Copy(_firstPath, _secondPath);
                    _resultString = "Success";
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message;
                }
            }
            else
            {
                _resultString = "The file doesn't exist or you don't have access to it";
            }

            return _resultString;
        }

        //Функция для перемещения файла
        public static string SqlMoveFile(string _firstPath, string _secondPath)
        {
            string _resultString;

            if (File.Exists(_firstPath) == true && File.Exists(_secondPath) == false)
            {
                try
                {
                    File.Move(_firstPath, _secondPath);
                    _resultString = "Success";
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message;
                }
            }
            else
            {
                _resultString = "The file doesn't exist or you don't have access to it";
            }

            return _resultString;
        }

        //Функция возвращающая дату и время последнего обращения к файлу
        public static string SqlGetLastAccessTime(string _path)
        {
            string _resultString;
            if (File.Exists(_path) == true)
            { 
                try
                {
                    _resultString = File.GetLastAccessTime(_path).ToString();
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message + _ex.HResult;
                }
            }
            else
            {
                _resultString = "The file doesn't exist or you don't have access to it";
            }
            return _resultString;
        }

        //Функция заменяющая содержимое заданного файла на содержимое другого файла, удаляя исходный файл и создавая резервную копию замененного файла
        public static string SqlReplaceFile(string _sourceFileName, string _destinationFileName, string _destinationBackupFileName)
        {
            string _resultString;

            try
            {
                File.Replace(_sourceFileName, _destinationFileName, _destinationBackupFileName, false);
                _resultString = "Success";
            }
            catch (Exception _ex)
            {
                _resultString = "Fail " + _ex.Message;
            }

            return _resultString;
        }

        //Функция проверяющаяя существует ли файл
        public static byte SqlExistsFile(string _path)
        {
            byte _result;

            if (File.Exists(_path) == true)
            {
                _result = 1;
            }
            else
            {
                _result = 0;
            }

            return _result;
        }

        //Функция считывающая весь текст файла
        public static byte[] SqlReadFile(string _path)
        {
            string[] _resultString;
            string res = "";
            byte[] _result;

            if (File.Exists(_path) == true)
            {
                try
                {
                    _resultString = File.ReadAllLines(_path);

                    foreach (string _string in _resultString)
                    {
                        res += _string + '\n';
                    }
                    
                }
                catch(Exception _ex)
                {
                    res = "Fail" + _ex.Message;
                }
            }
            else
            {
                res = "The file doesn't exist or you don't have access to it";
            }
            _result = Encoding.UTF8.GetBytes(res);

            return _result;
        }

        //Функция выводящая атрибуты файла
        public static string SqlGetAttributies(string _path)
        {
            string _resultString;

            try
            {
                FileAttributes _fileAttributes = File.GetAttributes(_path);
                _resultString = _fileAttributes.ToString();
            }
            catch (Exception _ex)
            {
                _resultString = "Fail " + _ex.Message;
            }

            return _resultString;
        }

        //Функция для записи текста в файл
        public static string SqlWriteText(string _path,string _text)
        {
            string _resultString;

            if (File.Exists(_path) == true)
            {
                try
                {
                    File.WriteAllText(_path, _text);
                    _resultString = "Success";
                }
                catch (Exception _ex)
                {
                    _resultString = "Fail " + _ex.Message;
                }
            }
            else
            {
                _resultString = "The file doesn't exist or you don't have access to it";
            }

            return _resultString;
        }

    }
}
