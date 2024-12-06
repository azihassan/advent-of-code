import std;

void main()
{
    int[][int] precedenceMap;
    foreach(line; stdin.byLine.map!idup.map!strip)
    {
        if(line.length == 0)
        {
            break;
        }
        int[2] rule;
        line.formattedRead!"%d|%d"(rule[0], rule[1]);
        precedenceMap[rule[0]] ~= rule[1];
    }

    int result;
    foreach(line; stdin.byLine.map!idup.map!strip)
    {
        int[] pages = line.splitter(",").map!(to!int).array();
        if(pages.isOrdered(precedenceMap))
        {
            result += pages[$ / 2];
        }
    }
    result.writeln();
}

bool isOrdered(int[] pages, int[][int] precedenceMap)
{
    foreach(i, page; pages)
    {
        if(pages[i + 1 .. $].any!(otherPage => otherPage in precedenceMap && precedenceMap[otherPage].canFind(page)))
        {
            return false;
        }
    }
    return true;
}
