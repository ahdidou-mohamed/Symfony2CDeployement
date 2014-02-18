<?php

namespace Blogger\BlogBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

//Comment 
class DefaultController extends Controller
{
    public function indexAction($name, $second, $how, $day)
    {

        return $this->render('BloggerBlogBundle:Default:index.html.twig', array('name' => $name, 'second'=>$second, 'how'=>$how, 'day'=>$day));

    }

    public function duplicate($name, $second, $how, $day)
    {

        return $this->render('BloggerBlogBundle:Default:index.html.twig', array('name' => $name, 'second'=>$second, 'how'=>$how, 'day'=>$day));

    }
}
