<?php

const path = __DIR__;

class MyDB extends SQLite3 {
  function __construct() {
     $this->open('lobby.db');
  }

  public function _prepareDb() {
    $sql = "
    DROP TABLE server;";

    $ret = $this->exec($sql);

    $sql = "
    CREATE TABLE server (
      ID INTEGER PRIMARY KEY,
      IP CHAR(50) NOT NULL,
      PORT INTEGER NOT NULL,
      ADDRESS_TYPE CHAR(3),
      USERNAME CHAR(50) NOT NULL,
      LASTUPDATE DATETIME NOT NULL,
      CONSTRAINT one_server_per_ip_and_port UNIQUE (IP, PORT, USERNAME)
    );";

    $ret = $this->exec($sql);
    if(!$ret) {
      $this->log('Error during create table: '. $this->lastErrorMsg());
      echo $this->lastErrorMsg();
    } else {
      // echo "Table created successfully\n";
    }
  }

  public function getServerList() {
    $date = new DateTime("-2 minute");
    $timestamp = $date->getTimestamp();

    list($timestamp) = 
      array_map(array(SQLite3, 'escapeString'), [$timestamp]);

    $sql = "
    SELECT * FROM server 
    WHERE LASTUPDATE > '$timestamp';";

    $ret = $this->query($sql);

    $servers = [];
    while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
      $servers[] = $row;
    }
    return $servers;
  }

  public function addServer($ip, $port, $type, $username) {

    $date = new DateTime();
    $timestamp = $date->getTimestamp();

    list($ip, $port, $type, $username, $timestamp) = 
      array_map(array(SQLite3, 'escapeString'), [$ip, $port, $type, $username, $timestamp]);

    $this->log('add server: '. print_r([$ip, $port, $type, $username, $timestamp], true));

    // $sql = "
    // INSERT INTO server (IP, PORT, ADDRESS_TYPE, USERNAME, LASTUPDATE)
    // VALUES ('$ip', '$port', '$type', '$username', '$timestamp');";

    $sql = "
    INSERT OR REPLACE INTO server (IP, PORT, ADDRESS_TYPE, USERNAME, LASTUPDATE)
    VALUES (  '$ip', '$port', '$type', '$username', '$timestamp' );
    ";

    $ret = $this->exec($sql);
    if(!$ret) {
      $this->log('Error during insert: '. $this->lastErrorMsg());
      return false;
    } else {
      // echo "Table insert successfully\n";
      $this->log('OK insert id: '. $this->lastInsertRowid());
      return $this->lastInsertRowid();
    }
  }

  public function heartBeat($serverid) {
    $date = new DateTime();
    $timestamp = $date->getTimestamp();

    $serverid = (int)$serverid;

    list($serverid, $timestamp) = 
      array_map(array(SQLite3, 'escapeString'), [$serverid, $timestamp]);

    $sql = "
    UPDATE server set LASTUPDATE = '$timestamp' WHERE ID = '$serverid';";

    $ret = $this->exec($sql);
    if(!$ret) {
      $this->log('Error during update: '. $this->lastErrorMsg());
      return false;
    } else {
      // echo "Table update successfully\n";
      return true;
    }
  }

  public function endServer($serverid) {
    $serverid = (int)$serverid;

    $timestamp = 0;

    list($serverid, $timestamp) = 
      array_map(array(SQLite3, 'escapeString'), [$serverid, $timestamp]);

    $sql = "
    UPDATE server set LASTUPDATE = '$timestamp' WHERE ID = '$serverid';";

    $ret = $this->exec($sql);
    if(!$ret) {
      $this->log('Error during update: '. $this->lastErrorMsg());
      return false;
    } else {
      // echo "Table update successfully\n";
      return true;
    }
  }

  public function log($text) {
    error_log( date('Y-m-d H:i:s') .' SQLite '. $text. "\n", 
      3, "lobby.log");
  }
}


function debug($text) {
  if(!empty($_GET['debug'])) {
    echo $text;
  }

  error_log( date('Y-m-d H:i:s') .' '. print_r($text, true), 
      3, "lobby.log");
}


$db = new MyDB();

// fresh setup of database
if(!empty($_GET['setup'])) {
  if(!$db){
    echo $db->lastErrorMsg();
  } else {
    echo "Opened database successfully\n";
    $db->_prepareDb();
  }
} 
// get list of active servers
else if(!empty($_GET['server']) && $_GET['server'] == 'list') {

  echo json_encode( $db->getServerList());
} 
// add new server to list
else if(!empty($_GET['server']) && $_GET['server'] == 'start') {
  
  $_POST['ip'] = trim($_POST['ip'], '[]');
  $ips = explode(',', $_POST['ip']);

  $serverid = [];
  foreach ($ips as $idx => $ip) {
    $ip = trim($ip);
    if(substr($ip, 0, 4) == '192.' || substr($ip, 0, 4) == '172.' || substr($ip, 0, 3) == '10.') {
      $type = 'int';
    } else {
      $type = 'ext';
    }
    $serverid[] = $db->addServer($ip, $_POST['port'], $type, $_POST['username']);
  }
  $result = $serverid;
  echo json_encode($result);
}
// update server (heartbeat)
else if(!empty($_GET['server']) && $_GET['server'] == 'ping') {
  $_POST['id'] = trim($_POST['id'], '[]');
  $ids = explode(',', $_POST['id']);

  foreach ($ids as $idx => $id) {
    $id = trim($id);
    $serverid[] = $db->heartBeat($id);
  }
  $result = $serverid;
  echo json_encode($result);

}
// close server - remove from list
else if(!empty($_GET['server']) && $_GET['server'] == 'close') {
  $_POST['id'] = trim($_POST['id'], '[]');
  $ids = explode(',', $_POST['id']);

  foreach ($ids as $idx => $id) {
    $id = trim($id);
    $serverid[] = $db->endServer($id);
  }
  $result = $serverid;
  echo json_encode($result);

} else {
  //header('HTTP/1.0 403 Forbidden', true, 403);  
  http_response_code(403);
  echo "Forbidden";
}

if(!empty($db)) {
  $db->close();
}