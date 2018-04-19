package configs

import (
	"github.com/go-ini/ini"
	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
	logger "github.com/cihub/seelog"
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
	ServerPort     int
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
var orm *xorm.Engine

func init() {
	var err error
	cfg, err := ini.Load(ConfigPath)
	if err != nil {
		logger.Error("Load config: %#v\n",err.Error())
	}

	//mode := cfg.Section("").Key("mode").Value()

	// APP
	AppName = cfg.Section("app").Key("name").Value()
	AppHost = cfg.Section("app").Key("host").Value()
	AppUrl = cfg.Section("app").Key("url").Value()
	AppVer = cfg.Section("app").Key("ver").Value()

	// SERVER
	ServerPort = cfg.Section("server").Key("port").MustInt(8080)
	ServerontextPath = cfg.Section("server").Key("context_path").Value()

	// ORM
	OrmDriverName = cfg.Section("orm").Key("driver_name").Value()
	OrmUrl = cfg.Section("orm").Key("url").Value()
	OrmMaxIdle = cfg.Section("orm").Key("max_idle_conn").MustInt(10)
	OrmMaxOpen = cfg.Section("orm").Key("max_open_conn").MustInt(10)
	OrmShowSql = cfg.Section("orm").Key("show_sql").MustBool(true)
	OrmLLogevel = cfg.Section("orm").Key("log_level").Value()

	//REDIS
	RedisDatabase = cfg.Section("redis").Key("database").Value()
	RedisHost = cfg.Section("redis").Key("host").Value()
	RedisPort = cfg.Section("redis").Key("port").MustInt(3379)
	RedisTimeout = cfg.Section("redis").Key("timeout").MustInt(10)

	orm, err = xorm.NewEngine(OrmDriverName, OrmUrl)
	if err != nil {
		logger.Error("db error: %#v\n", err.Error())
	}
}