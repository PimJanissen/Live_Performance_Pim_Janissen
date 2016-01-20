// <copyright file="DatabaseManager.cs" company="Live_Performance_Pim_Janissen">
//      Copyright (c) PimJanissen. All rights reserved.
// </copyright>
// <author>Pim Janissen</author>
namespace Live_Performance_Pim_Janissen
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Oracle.DataAccess.Client;

    /// <summary>
    /// Static DatabaseManager class, used to connect to the database and manipulate the data in it via queries.
    /// Exceptions are thrown without any handling.
    /// </summary>
    public static class DatabaseManager
    {
        #region Fields
        /// <summary>
        /// Constant variables containing the information required to open the database connection.
        /// </summary>
        private const string ConnectionId = "DBI324928", ConnectionPassword = "oBVmntOXe6", ConnectionAddress = "//192.168.15.50:1521/fhictora";

        /// <summary>
        /// static OracleConnection used to open the database connection, run queries and close it afterwards.
        /// </summary>
        private static OracleConnection connection = new OracleConnection(ConnectionString);

        #endregion Fields

        #region Properties

        /// <summary>
        /// Gets the connection string used to open the database connection.
        /// </summary>
        private static string ConnectionString
        {
            get
            {
                return string.Format("Data Source={0};Persist Security Info=True;User Id={1};Password={2}", ConnectionAddress, ConnectionId, ConnectionPassword);
            }
        }

        #endregion Properties

        #region Private Methods

        /// <summary>
        /// Creates an OracleCommand for the given query using the static OracleConnection field, and sets the CommandType to CommandType.Text (used for plain text queries).
        /// Used prior to adding parameters and executing the query.
        /// </summary>
        /// <param name="sql">Query string to run</param>
        /// <returns>OracleCommand with the query and connection information set</returns>
        private static OracleCommand CreateOracleCommand(string sql)
        {
            OracleCommand command = new OracleCommand(sql, connection);
            command.CommandType = System.Data.CommandType.Text;

            return command;
        }

        /// <summary>
        /// Runs the query of an OracleCommand, and returns an unread OracleDataReader with the results of the query.
        /// </summary>
        /// <param name="command">OracleCommand containing the data for the query</param>
        /// <returns>OracleDataReader with the result of the query</returns>
        private static OracleDataReader ExecuteQuery(OracleCommand command)
        {
            try
            {
                if (connection.State == ConnectionState.Closed)
                {
                    try
                    {
                        connection.Open();
                    }
                    catch (OracleException exc)
                    {
                        throw;
                    }
                }

                OracleDataReader reader = command.ExecuteReader();

                return reader;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Runs the command in the given OracleCommand with ExecuteNonQuery; which is used for queries where no data is returned (in an OracleDataReader).
        /// Return value indicates if any rows are updated.
        /// </summary>
        /// <param name="command">OracleCommand containing the data for the query.</param>
        /// <returns>True when at least one row is updated.</returns>
        private static bool ExecuteNonQuery(OracleCommand command)
        {
            if (connection.State == ConnectionState.Closed)
            {
                connection.Open();
            }

            return command.ExecuteNonQuery() != 0;
        }

        #endregion Private Methods

        #region Methods
        #endregion Methods
    }
}
