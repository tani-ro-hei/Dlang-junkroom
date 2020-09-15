use 5.30.0;
use warnings;
use utf8;

use FindBin;
use Encode  qw( encode decode );
my ($here, $lib);
BEGIN {
    $here = decode 'cp932', $FindBin::Bin;
    $lib  = encode 'cp932', "$here/../../lib";
}
use lib "$lib";

use T 0.10  qw( timer msg in sjenc remover pscall );
use T::Header;
BEGIN {
    eval &T_HDR('noXtr');
    die "$@" if $@;

    $SIG{__WARN__} = sub {
        warn $_[0];
        push @::_warns, $_[0];
    };
}
timer;
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

my @dirs = ('.template');
push @dirs, (grep { /^[^\.]/ } in '<d', $here);

while (1) {
    my @delpath;
    foreach my $d (@dirs) {
        my $dub = "$here/$d/.dub";
        my $exe = "$here/$d/$d.exe";
        push @delpath, $dub if -e sjenc $dub;
        push @delpath, $exe if -e sjenc $exe;
    }
    last unless @delpath;

    {
        local $SIG{__WARN__} = sub {};
        sleep 0.1;

        eval {
            remover \@delpath, { msgskip => 1 };
        };
    }
}


chomp(my $home = pscall '$env:HOMEPATH');
$home = "C:$home";

foreach my $d (@dirs) {
    my $srcdir = "$here/$d";
    my $dstdir = "$home/Documents/GitHub/Dlang-junkroom/$d";

    &callrobo( $srcdir, $dstdir,
        q!robocopy "<Src>" "<Dst>" ! .
        q!/UNILOG+:"<Log>" /MIR /R:1 /W:1 /NP /TEE /XJD /XJF /COPY:D /NODCOPY /NDL /XO!
    );
}

do {
    my $srcdir = "$here";
    my $dstdir = "$home/Documents/GitHub/Dlang-junkroom";

    &callrobo( $srcdir, $dstdir,
        q!robocopy "<Src>" "<Dst>" .gitattributes README.md util.pl ! .
        q!/UNILOG+:"<Log>" /R:1 /W:1 /NP /TEE /XJD /XJF /COPY:D /NODCOPY /NDL /XO!
    );
};


sub callrobo {

    my ($srcdir, $dstdir, $cmd) = @_;
    my $logf = "$here/robocopy.log";

    for ($srcdir, $dstdir, $logf) {
        s!/!\\!g;
    }
    for ($cmd) {
        s!<Src>!$srcdir!;
        s!<Dst>!$dstdir!;
        s!<Log>!$logf!;
    }

    msg "$cmd\n\n";
    pscall $cmd;
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
timer msg => "正常終了。__SEC__ 秒かかりました";
push @::_warns, "<ALL GREEN>.\n" unless @::_warns;
msg "TRAPPED_WARNINGS: $_\n" for @::_warns; @::_warns = ();

<STDIN>;
