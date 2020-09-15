/*
 *  Hello D-world collection.
 *  (hello に移動し、dub test で検証、dub run -q で実行)
 */

// imports (適当にいっぱい)
import std.stdio;
import std.algorithm, std.conv, std.range;
import std.ascii, std.regex, std.string;
import std.datetime;
import std.windows.charset;


void display(void function() fn, ref uint cnt)
{
    writefln(">>>>> (%s) >>>>>", ++cnt);
    fn();
    writefln("<<<<< (%s) <<<<<", cnt);
}

void main()
{
    uint cnt = 0;

    display(&hello1, cnt);
    display(&hello2, cnt);
    display(&hello3, cnt);
    display(&hello4, cnt);
    display(&hello5, cnt);
    //display(&hello6, cnt);
    //display(&hello7, cnt);
    //display(&hello8, cnt);
    //display(&hello9, cnt);
}
// ==============================


// #標準出力とエンコードのテスト
void hello1()
{
    writeln("Hello, World!");

    // UFCS 利用
    "hello world\n".write();

    // Shift_JIS でターミナル出力
    write(sjenc("こんにちは、世界！\n"));
}

string sjenc(string str)  { return(str.toMBSz.to!string); }
string sjdec(string str)  { return(str.toStringz.fromMBSz); }
string eucenc(string str) { return(str.toMBSz(20932).to!string); }
string eucdec(string str) { return(str.toStringz.fromMBSz(20932)); }

unittest
{
    assert("日本語表現".sjenc.sjdec.eucenc.eucdec == "日本語表現");
    assert("日本語表現".sjenc != "日本語表現");
}

// #ループ構文のテスト
void hello2()
{
    immutable int sup = 6;
    immutable int min = 7;

    // ブレースは必須ではない
    foreach(int a; 3 .. sup)
        foreach(int b; min .. 9)
            writef("%s:%s ", a, b);
    writeln("");


    char[] helloArr = ['h', 'E', 'l', 'L', 'o',];
    assert(helloArr.length == 5);

    // 逆順で実行されてゆく
    scope(exit)    write("!\n");
    scope(success) write("RlD");
    scope(exit)    write("Wo");
    scope(success) write(", ");

    // なんとなくミクスイン
    mixin("int sum = 0;");

    foreach(idx, chr; helloArr) {
        write(chr);
        sum += idx;
    }
    writef("(0+1+2+3+4=%s)", sum);
}

// #配列と辞書のテスト
void hello3()
{
    {
        dchar[] arr1 = ['h', 'e'];
        dchar[] arr2 = ['l', 'l', 'o', '!'];
        dchar[][] arr = [arr1, arr2];
        writefln("<%(%(%s/%):%)>", arr);
    }

    string[string] dict;
    char[] hg = "hoge".dup;
    dict[ hg.idup ] = "fuga";
    dict._piyolize("hoge");
    dict["hoge"].writeln();

    dict.remove("hoge");
    if(!("hoge" in dict)) {
        writeln("key<hoge> is removed!");
    }
}

void _piyolize(ref string[string] dict, string str)
{
    dict[ str ] = "piyo";
}

// #ファイル入出力テスト
void hello4()
{
    string iof = "./IO-file";

    {
        // 読込みモード
        auto testfile = File(iof, "r");

        int i = 0;
        foreach(line; testfile.byLine) {
            if(i++ == 1) {
                // 改行は勝手に除かれている？
                writeln(line);
            }
        }
    }
    // スコープを抜けると リファレンスカウントにより自動で close する

    {
        // 追記モード
        auto testfile = File(iof, "a");

        // 実行時を追記する
        auto curr = Clock.currTime().toString();
        testfile.writeln("added at ", curr);
    }
}

// #例外処理のテスト
void hello5()
{
    {
        // ブロックスコープでインポート
        import std.math : PI;

        "%s".writefln(PI);
    }

    // これはシステム Error なので catch できない
    //"%s".writefln(PI);


    try {
        throw new Exception("Hello Err World");
    }
    catch(Exception e) {
        write(e.msg);
    }
    finally {
        writeln("!!");
    }
}

//void hello6(){}
//void hello7(){}
//void hello8(){}
//void hello9(){}
