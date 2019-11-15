const Sequelize = require("sequelize")
const db_local = {}
// const sequelize = new Sequelize("database", "user", "password", {
const sequelize = new Sequelize("soccer_player", "postgres", "ModoC2019", {
    host: 'localhost',
    // host: 'ransa-dev-web.cs0zzjwqt6zc.us-east-1.rds.amazonaws.com',
    port: 5432,
    dialect: 'postgres',
    operatorsAliases: false,

    pool: {
        max: 10,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
})

db_local.sequelize = sequelize
db_local.Sequelize = Sequelize

module.exports = db_local