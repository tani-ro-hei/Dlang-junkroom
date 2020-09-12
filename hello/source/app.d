/*
 *  Hello D-world collection.
 *  (hello に移動し、dub run -q で実行)
 */


// imports (適当にいっぱい)
import std.stdio;
import std.algorithm, std.conv, std.range;
import std.ascii, std.regex, std.string;
import std.datetime;


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
    //display(&hello5, cnt);
    //display(&hello6, cnt);
    //display(&hello7, cnt);
    //display(&hello8, cnt);
    //display(&hello9, cnt);
}


// ====================

// # 標準出力のテスト
void hello1()
{
    writeln("Hello, World!");

    // UFCS 利用
    "hello world\n".write();
}

// # ループ構文のテスト
void hello2()
{
    immutable int sup = 6;

    foreach(int a; 3 .. sup) {
        foreach(int b; 7 .. 9) {
            writef("%s:%s ", a, b);
        }
    }
    writeln("");
}

// # 辞書のテスト
void hello3()
{
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

// # ファイル入出力テスト
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

//void hello5(){}
//void hello6(){}
//void hello7(){}
//void hello8(){}
//void hello9(){}
