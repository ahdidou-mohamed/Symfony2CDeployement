<?php

namespace Blogger\BlogBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DefaultController extends Controller
{
    public function indexAction($name, $second, $how)
    {
        return $this->render('BloggerBlogBundle:Default:index.html.twig', array('name' => $name, 'second'=>$second, 'how'=>$how));
    }
}
