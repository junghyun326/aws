<?php

$conn = new mysqli('database-1.c6rzawcep8c6.ap-northeast-2.rds.amazonaws.com','admin','mode1752');
if(!$conn){
        die('could not connect:'.mysqli_error($conn));
}
//echo 'Connected Successfully';
$selDb=mysqli_select_db($conn, 'RDS');
if(!$selDb){
        die('can not use RDS :'.mysqli_error($conn));
}


switch($_GET['mode']){
        case 'insert':
                if($_POST['url']!=null){
                        $insert=mysqli_query($conn, 'insert into blog (url,description) value ("'.$_POST['url'].'","'.$_POST['description'].'")' );
                        if(!$insert){
                        die('Invalid query :'.mysqli_error($conn));
                        }

                }
                header('Location: index.php');

                break;
        case 'delete':
                $delete=mysqli_query($conn, 'delete from blog where id='.$_POST['id']);
                if(!$delete){
                        die('Invalid query :'.mysqli_error($conn));
                }
                header('Location: index.php');
                break;

        case 'modify':
                $update=mysqli_query($conn, 'update blog set url="'.$_POST['url'].'",description="'.$_POST['desc'].'" where id='.$_POST['id']);
                if(!$update){
                        die('Invalid query :'.mysqli_error($conn));
                }
                header('Location: index.php');
                break;
        default:
                header('Location: index.php');
                break;
        }

?>
