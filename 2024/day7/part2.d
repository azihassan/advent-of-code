import std;

void main()
{
    ulong totalCalibrationResult;
    foreach(i, line; stdin.byLine.map!idup.map!strip.enumerate)
    {
        writeln(i);
        string[] parts = line.split(" ");
        ulong expectedResult = parts[0][0 .. $ - 1].to!ulong;
        ulong[] equation = parts[1 .. $].map!(to!ulong).array();

        ulong calibrations = countOperators(expectedResult, equation);
        if(calibrations == 0)
        {
            continue;
        }
        totalCalibrationResult += expectedResult;
    }
    totalCalibrationResult.writeln();
}

ulong countOperators(ulong expectedResult, ulong[] equation)
{
    ulong count;
    dchar[] operators = ['+', '*', '|'];
    foreach(operatorCombination; operators.combinations(equation.length - 1))
    {
        bool resultExceeded;
        ulong actualResult = equation.evalulate(operatorCombination, expectedResult, resultExceeded);
        if(!resultExceeded)
        {
            count += actualResult == expectedResult;
        }
    }
    return count;
}

dchar[][] combinations(dchar[] input, ulong length)
{
    if(length == 1)
    {
        return input.map!(c => [c]).array;
    }

    dchar[][] result;
    foreach(i; 0 .. input.length)
    {
        foreach(c; memoize!combinations(input, length - 1))
        {
            result ~= [input[i] ~ c];
        }

    }
    return result;
}

ulong evalulate(ulong[] equation, dchar[] operators, ulong expectedResult, out bool resultExceeded)
{
    ulong equationIndex = 0;
    ulong result = equation[equationIndex];

    equationIndex++;
    foreach(i, operator; operators)
    {
        if(operator == '+')
        {
            result += equation[equationIndex];
        }
        else if(operator == '*')
        {
            result *= equation[equationIndex];
        }
        else
        {
            //result = concatenate(result, equation[equationIndex]);
            result = to!ulong(result.to!string ~ equation[equationIndex].to!string);
        }
        if(result > expectedResult)
        {
            resultExceeded = true;
            return 0;
        }
        equationIndex++;
    }
    return result;
}

ulong concatenate(ulong a, ulong b)
{
    int length = 1;
    while(length < b)
    {
        length *= 10;
    }
    return a * length + b;
}
