const { expect } = require("chai");
const { ethers } = require("hardhat");

//Blog is the test name
describe("Blog", async function () {
  //testing blog create method
  it("Should create a post", async function () {
    const Blog = await ethers.getContractFactory("Blog"); //instance of our Blog contract
    const blog = await Blog.deploy("My blog");
    await blog.deployed();
    await blog.createPost("My first post", "12345");

    const posts = await blog.fetchPost();
    expect(posts[0].title).to.equal("My first post");
  });

  //testing blog edit method
  it("Should edit a post", async function () {
    const Blog = await ethers.getContractFactory("Blog");
    const blog = await Blog.deploy("My blog");
    await blog.deployed();
    await blog.createPost("My Second posts", "12345");

    await blog.updatePost(1, "My updated post", "23456", true);

    posts = await blog.fetchPosts();
    expect(posts[0].title).to.equal("My updated post");
  });

  //testing updating the blog name
  it("Should update the name", async function () {
    const Blog = await ethers.getContractFactory("Blog");
    const blog = await Blog.deploy("My blog");
    await blog.deployed();

    expect(await blog.name()).to.equal("My Blog");
    await blog.updateNAme("My new blog");
    expect(await blog.name()).to.equal("My new blog");
  });
});
