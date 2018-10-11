module.exports = {
  client: 'postgresql',
  connection: {
    database: "{{ swapcoins_app_api_postgres_database }}",
    user: "{{ swapcoins_app_api_postgres_user }}",
    password: "{{ swapcoins_app_api_postgres_password }}",
    port: "{{ swapcoins_app_api_postgres_port }}",
    host: "{{ swapcoins_app_api_postgres_host }}",
  },
  migrations: {
    tableName: 'migration',
  },
  pool: {
    requestTimeout: 30000,
  },
  debug: false,
  acquireConnectionTimeout: 60000,
};
