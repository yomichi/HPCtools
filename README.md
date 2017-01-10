# SekireiTools

物性研共同利用スパコンシステムB (sekirei) のためのツールです。

# ログインノードで使うスクリプト

## `qnodes`
現在動いているジョブの一覧およびキューごとの使用中ノードの数を、
通常キュー(F)、長時間キュー(L)、バックグラウンドキュー(L) の区別なく表示します。

たとえば `qnodes small` とすると、 `F4cpu`, `L4cpu`, `B4cpu` キューで動いているジョブおよび占有ノードの合計数が表示されます。
`qnodes` と実行すると、有効な引数の一覧が出力されるので、適当なキューを選んで再度実行してください。

## `qrack`
現在のラック状況を表示します。
小文字アルファベットがF キュー、大文字アルファベットがL キュー、数字・記号がB キュー、`_` が空きノードを意味します。

`qnodes` と同様にキューの種類を指定することもできます。

## `myjobs`
自分の投入したジョブの一覧を表示します。
最終列は、ステータスが `R` の場合には実行時間を、
ステータスが `Q` （実行待ち）の場合には実行開始予想時刻を表示します。

ユーザ名を空白区切りもしくは改行区切りで列挙して記入したファイルを、
`myjobs` と同じディレクトリに `users.txt` という名前でおいておくと、
複数ユーザについてジョブ状況を確認できます。

## `mkjobsh`
``` bash
usage="usage: mkjobsh [--queue=(cpu|acc|fat|icpu|iacc|ifat)] [--omp=NUM_OPENMP] [--node=NUM_NODE] [--hours=HOURS] [--minutes=MINUTES] [--name=JOB_NAME]"
```

ジョブ投入用のスクリプトの雛形を生成し、標準出力に書き出します。

- `--omp=<NUM_OPENMP>`
    - MPIプロセスあたりのOpenMP スレッド数を指定できます。
    - デフォルト値は24
    - 指定可能なスレッド数は24 の約数だけです。
- `--node=<NUM_NODE>`
    - 使用ノード数を指定できます。
    - デフォルト値は1
    - 使用するキューも自動で切り替わります。
- `--queue=(cpu|acc|fat|icpu|iacc|ifat)`
    - 使うキューを切り替えられます。
    - デフォルトはcpu
    - i はインタラクティブキューです。
        - ジョブ時間は強制的に30分になります。
- `--hours=HOURS` と `--minutes=MINUTES` 
    - 要求時間を指定できます。
    - デフォルトは24時間
    - 24時間を超えた場合は自動的にL キューに切り替えます。
`--name=<JOB_NAME>`
    - ジョブ名を指定できます。
    - デフォルトは "test"

## `qsh`
``` bash
usage: qsh [--queue=(cpu|acc|fat)] [--omp=<NUM_OPENMP>] <NUM_NODES>
```

インタラクティブジョブを投入し、ログインします。
引数として使用ノード数を指定できます（デフォルト値は1）。
`--omp=<NUM_OPENMP>` オプションを使うことで、MPIプロセスあたりのOpenMP スレッド数を指定できます（デフォルト値は24）。指定可能なスレッド数は24 の約数だけです。
`--queue=(cpu|acc|fat)` オプションによって、使うキューを切り替えられます（デフォルトはcpu）

## `qchain`
``` bash
usage: qchain [--ok] [--notok] [--num=<number of chain>] <scriptname>
```

与えたジョブスクリプト `<scriptname>` を、与えた回数 `<number of chain>` だけ繰り返すチェーンジョブを投入します。
デフォルトでは `afterany` でつながりますが、 `--ok` や `--notok` を指定することで `afterok` および `afternotok` でつなげることができます。

## `touch.sh`
ユーザの `/work` 領域にある全てのファイルのうち、最終更新が1週間以上前のファイルのタイムスタンプを更新します。

# 計算ノードで使うスクリプト

## `jobid`
ジョブID を返します。

## `machinefile`
割り当てられたノード名を列記します。
引数として `julia` を渡すと、julia の`--machinefile` フォーマットで表示します。
また、引数として `parallel` を渡すと、GNU parallel の`--sshloginfile` フォーマットで表示します。

## `parallel.jl`
ジョブスケジューリングを行います。
引数として、ジョブリストファイルを渡してください。
ジョブリストファイルの各行に、並列に実行したいコマンドを記入してください。
`;` や`&&` などを利用することで、複数コマンドを逐次的に実行することも可能です。

```
> cat job.txt
./a.out input.001
./a.out input.002
./a.out input.003
 ...
./a.out input.100

> parallel.jl job.txt
```

各ジョブの標準出力と標準エラー出力は、 `(JOBID)-(WORKERID).out`, `(JOBID)-(WORKERID).err` に保存されます。

実行の際には、[Julia](http://julialang.org) インタプリタに実行パスを通す必要があります。
複数ノードを利用しても、ジョブ数が割当コア数よりも多くても機能します。
現在はシリアルジョブの並列実行のみに対応しています。

ちゃんとメンテナンスしていないため、GNU parallel を使ったほうが幸せになれるような気がします。
いつかラッパを書きます。

```
> machinefile parallel > host.txt
> parallel --slf host.txt --workdir . --env PATH,LD_LIBRARY_PATH "{}" :::: job.txt
```

# ライセンス
Copyright: Yuichi Motoyama y-motoyama@issp.u-tokyo.ac.jp

`utconv` を除き、[Boost Software License Version 1.0](http://www.boost.org/LICENSE_1_0.txt) の元で公開しています。
`utconv` は[パブリックドメインにて公開されているもの](https://github.com/ShellShoccar-jpn/misc-tools)を再配布しています。

本スクリプト集は無保証です。ご自身の責任において使用してください。
