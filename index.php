<!DOCTYPE html>
<html>
    <head>
        <TITLE> Blog management</TITLE>
       
    </head>   
    <body>
        <H2>BLOG MANAGEMENT</h2>

        <table border='1'>
            <tr align='center'>
                <td>
                    <p>ID</p>
                </td>
                <td>
                    <p>URL</p>
                </td>
                <td>
                    <p>DESCRIPTION</p>
                </td>
                <td>
                    <p>DELETE/MODIFY</p>
                </td>
            </tr>
        <?php
 
        $conn = new mysqli('database-1.c6rzawcep8c6.ap-northeast-2.rds.amazonaws.com','admin','mode1752');
        if(!$conn){
            die('could not connect:'.mysqli_error($conn));
        }
        $selDb = mysqli_select_db($conn, 'RDS');
        if(!$selDb){
            $createDB = mysqli_query($conn, 'create database RDS');
            $useDB = mysqli_query($conn, 'use RDS');
            $createTable = mysqli_query($conn, 'create table blog(
                                        id int not null auto_increment, 
                                        url text not null, 
                                        description text null, 
                                        constraint pk primary key(id) 
                                        )');
        }
        $queryData = mysqli_query($conn, 'select * from blog');
        if(!$queryData){
            echo('query error :'.mysqli_error($conn));
        }
        while($row = mysqli_fetch_assoc($queryData)){

            echo '<tr><form action="./management.php?mode=modify" method="POST">
            <td><input name="id" value="'.$row['id'].'" readonly size=1/></td>
            <td><input name="url" value="'.$row['url'].'"/></td>
            <td><input name="desc" value="'.$row['description'].'"/></td>
            <td>
            <input type="submit" value="MODIFY"/>
            </form>

            <form action="./management.php?mode=delete" method="POST">
            <input type="hidden" name="id" value="'.$row['id'].'"/>
            <input type="submit" value="DELETE"/>
            </form>
            </td>';
            
        }
        ?>          
                 
        </tr>
        </table>

        <p>ADD DATA</p>
        <form action="./management.php?mode=insert" method="POST">
            <table border='1'>
                <tr>
                    <td align='center'>
                       <p> BLOG URL</p>
                    </td>
                    <td>
                        <input type="text" name="url" size='25'>   
                    </td>
                </tr>

                <tr>
                    <td align='center'>
                        <p>DESCRIPTION</p>
                    </td>
                    <td>
                        <input type="text" name="description" size='25'/>
                    </td>

                </tr>

                <tr align='center'>
                    <td>
                        <p>ADD</p>
                    </td>
                    <td>
                        <input type="submit" value="send"/>            
                    </td>
                </tr>

            </table>
        </form>
        <br/>
        <br/>
        <a href="https://jeonghyun-static.cf/index.html">Static Web Page</a>
    </body>
</html>
