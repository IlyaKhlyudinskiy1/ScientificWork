using System;
using System.Text.RegularExpressions;

namespace RegularLibrary
{
    public class Regular_fn
    {
        public static string SqlRegularExpression(string _pattern, string _text)
        {
            string _result;

            bool _isMatch;

            try 
            {
                _isMatch = Regex.IsMatch(_text, _pattern);

                if (_isMatch == true)
                {
                    _result = "Match";
                }
                else
                {
                    _result = "Not match";
                }
            }
            catch(Exception _ex) 
            {
                _result = "Fail" + _ex;
            }

            return _result;
        }

        public static string SqlRegularReplace(string _text, string _pattern, string _replacement)
        {
            string _resultString = "";

            try
            {
                _resultString = Regex.Replace(_text, _pattern, _replacement);
            }
            catch(Exception _ex)
            {
                _resultString += _ex;
            }

            return _resultString;
        }
    }
}
