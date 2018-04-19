package configs

import (
	"log"
	"github.com/go-ini/ini"
	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
)

var (
	ConfigPath   = "configs/config.ini"
)

//APP
var (
	AppName             string
	AppHost             string
	AppUrl              string
	AppVer              string
)

// SERVER
var (
	ServerPort     string
	ServerontextPath string
)

// ORM
var (
	OrmDriverName string
	OrmUrl string
	OrmMaxIdle    int
	OrmMaxOpen    int
	OrmShowSql		bool
	OrmLLogevel   string
)

// REDIS
var (
	RedisDatabase  string
	RedisHost       string
	RedisPort		int
	RedisTimeout	int
)

// orm 全局DB
var engine *xorm.Engine

func init() {
	var err error
	cfg, err := ini.Load(ConfigPath)
	if err != nil {
		log.Fatal(err)
	}


	OrmDriverName = cfg.Section("orm").Key("driver_name").Value()
	OrmUrl = cfg.Section("orm").Key("url").Value()
	OrmMaxIdle = cfg.Section("orm").Key("max_idle_conn").MustInt(10)
	OrmMaxOpen = cfg.Section("orm").Key("max_open_conn").MustInt(10)
	OrmShowSql = cfg.Section("orm").Key("show_sql").MustBool(true)
	OrmLLogevel = cfg.Section("orm").Key("log_level").Value()

	engine, err = xorm.NewEngine(OrmDriverName, OrmUrl)

	if err != nil {
		log.Fatalf("db error: %#v\n", err.Error())
	}
}