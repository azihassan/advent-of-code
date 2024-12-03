import std;

void main()
{
    long result;
    foreach(line; stdin.byLine.map!idup)
    {
        result += line.evaluate();
    }
    result.writeln();
}

long evaluate(string memory)
{
    long sumOfProducts;
    size_t index;
    while(index < memory.length)
    {
        try
        {
            long a, b;
            memory[index .. $].formattedRead!"mul(%d,%d)"(a, b);
            sumOfProducts += a * b;
            index += format!"mul(%d,%d)"(a, b).length;
        }
        catch(FormatException e)
        {
            index++;
            continue;
        }
    }
    return sumOfProducts;
}
