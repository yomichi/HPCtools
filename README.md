# SekireiTools

物性研共同利用スパコンシステムB (sekirei) のためのツールです。

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

## `jobid`
ジョブID を返します。

## `machinefile`
割り当てられたノード名を列記します。
引数として `julia` を渡すと、julia の`--machinefile` フォーマットで表示します。

## `touch.sh`
ユーザの `/work` 領域にある全てのファイルのうち、最終更新が1週間以上前のファイルのタイムスタンプを更新します。

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

## ライセンス
Copyright: Yuichi Motoyama y-motoyama@issp.u-tokyo.ac.jp

`utconv` を除き、[Boost Software License Version 1.0](http://www.boost.org/LICENSE_1_0.txt) の元で公開しています。
`utconv` は[パブリックドメインにて公開されているもの](https://github.com/ShellShoccar-jpn/misc-tools)を再配布しています。

本スクリプト集は無保証です。ご自身の責任において使用してください。
