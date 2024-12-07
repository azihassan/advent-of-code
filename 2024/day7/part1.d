import std;

void main()
{
    ulong totalCalibrationResult;
    foreach(line; stdin.byLine.map!idup.map!strip)
    {
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
    dchar[] operators = ['+', '*'];
    foreach(combination; operators.combinations(equation.length - 1))
    {
        count += equation.evalulate(combination) == expectedResult;
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
        foreach(c; combinations(input, length - 1))
        {
            result ~= [input[i] ~ c];
        }

    }
    return result;
}

ulong evalulate(ulong[] equation, dchar[] operators)
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
        else
        {
            result *= equation[equationIndex];
        }
        equationIndex++;
    }
    return result;
}
