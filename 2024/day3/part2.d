import std;

void main()
{
    stdin.byLine.map!idup.join("").evaluate().writeln();
}

long evaluate(string memory)
{
    long sumOfProducts;
    bool enabled = true;
    size_t index;
    while(index < memory.length)
    {
        if(memory[index .. $].startsWith("don't()"))
        {
            enabled = false;
            index += "don't()".length;
            continue;
        }
        if(memory[index .. $].startsWith("do()"))
        {
            enabled = true;
            index += "do()".length;
            continue;
        }

        if(!enabled)
        {
            index++;
            continue;
        }

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


unittest
{
    assert("do()don't()do()mul(1,2)foobarmul(2,2)don't()mul(3,3)".evaluate() == 1*2 + 2*2);
}
