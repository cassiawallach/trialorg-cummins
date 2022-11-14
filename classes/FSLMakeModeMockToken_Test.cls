@isTest
global class FSLMakeModeMockToken_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response added comment
        HttpResponse res = new HttpResponse();
         res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1579149519","not_before":"1579145619","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-engine","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSIsImtpZCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWktZW5naW5lIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsImlhdCI6MTU3OTE0NTYxOSwibmJmIjoxNTc5MTQ1NjE5LCJleHAiOjE1NzkxNDk1MTksImFpbyI6IjQyTmdZSGk2cVY0cUtMaC80bXlHdFMwZm95S1hBUUE9IiwiYXBwaWQiOiJhZDcyNDM5Mi01NTk0LTRlODUtYjllYi1iMGZjMTljMmZhYmUiLCJhcHBpZGFjciI6IjEiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwib2lkIjoiYmJiZjM1NDItYmY2NS00YjM5LWFiMzgtMzAwMzY2Y2ZiYjBkIiwic3ViIjoiYmJiZjM1NDItYmY2NS00YjM5LWFiMzgtMzAwMzY2Y2ZiYjBkIiwidGlkIjoiYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkIiwidXRpIjoicG0xR3pXMHByVVN0dTJoUXI5QUtBQSIsInZlciI6IjEuMCJ9.lbM1dPpu0tP29Xq6WB7pKIbB36afywSQ1NpwjC8YpyDDNy9zI27PX4FfNqwWr0tCRcju_vp5UJDrlFkKLb3iS9wX9WeEi4ubTilnYYTs-Gtg9kEBd4GKDR-6nQ9-6wJp39gcrMT517eufawqBqNeQIk4jbQHn39WQsZj61SaXZiyP1oq2nu2HmekNF_UIvPV9jlRJEQ2MYAMwiIR0AW10xsjMyEaxXim_WzMMDeQHdGtkFYg0EF7YPi4pf2TG60xgKD0qdwFf67j2gsTiJpl55QAmkmlt7TNPZZlhyEbvrx5Yy_RU-cpCJWgAn8d8GXTLKagu_RmcBxliR1dn-DZsg"}');
            
            return res; 
    }
}