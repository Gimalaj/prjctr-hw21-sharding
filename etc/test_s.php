<?php

    $pgdb = new PDO("pgsql:host=host.docker.internal;port=5432;dbname=postgres;", "postgres", "postgres");

    const _INSERT_RECORDS = 1000000;

    $start = (time()-1683096576)*1000000;

    $total_time = 0;

    for($i = 1; $i <= _INSERT_RECORDS; $i++) {
        $req_start = microtime(true);
        $pgdb->query("INSERT INTO books (id,category_id,author,title,year) VALUES (".($start+$i).",".mt_rand(1,3).",'author','title',2020)");
        $total_time += microtime(true)-$req_start;
        echo $i."\n";
    }

    echo "avg req time ".round($total_time/_INSERT_RECORDS,6)."\n";