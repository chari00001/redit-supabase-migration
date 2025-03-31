// Supabase integration for redit-backend
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

// Supabase connection details
const supabaseUrl = 'https://qjezggefroennnhwffpr.supabase.co';
const supabaseKey = process.env.SUPABASE_SERVICE_KEY || ''; // Use service role key for migrations

// Initialize Supabase client
const supabase = createClient(supabaseUrl, supabaseKey);

async function executeSQL() {
  try {
    console.log('Starting Supabase migration...');

    // Read SQL file
    const sqlPath = path.join(__dirname, 'migration.sql');
    const sqlContent = fs.readFileSync(sqlPath, 'utf8');
    
    // Split the SQL by semicolons to execute statements separately
    const sqlStatements = sqlContent.split(';')
      .map(statement => statement.trim())
      .filter(statement => statement.length > 0);
    
    console.log(`Found ${sqlStatements.length} SQL statements to execute`);
    
    // Execute each SQL statement
    for (let i = 0; i < sqlStatements.length; i++) {
      const statement = sqlStatements[i];
      
      try {
        console.log(`Executing statement ${i+1}/${sqlStatements.length}`);
        // Execute the SQL using Supabase's rpc function for raw SQL
        const { data, error } = await supabase.rpc('exec_sql', { sql: statement + ';' });
        
        if (error) {
          console.error(`Error executing statement ${i+1}:`, error);
        } else {
          console.log(`Successfully executed statement ${i+1}`);
        }
      } catch (statementError) {
        console.error(`Exception executing statement ${i+1}:`, statementError);
      }
    }
    
    console.log('Migration completed successfully');
  } catch (error) {
    console.error('Migration failed:', error);
  }
}

// Check if we have a service key before running
if (!supabaseKey) {
  console.error('Error: SUPABASE_SERVICE_KEY environment variable is not set');
  console.error('Please set your Supabase service role key to execute migrations');
  process.exit(1);
}

// Run the migration
executeSQL();

// Notes on how to use:
// 1. Create a stored procedure in Supabase to execute raw SQL:
/*
  -- As a superuser in Supabase SQL editor:
  CREATE OR REPLACE FUNCTION exec_sql(sql text) RETURNS void AS $$
  BEGIN
    EXECUTE sql;
  END;
  $$ LANGUAGE plpgsql SECURITY DEFINER;
*/
// 2. Set SUPABASE_SERVICE_KEY environment variable
// 3. Run this script: node supabase-integration.js