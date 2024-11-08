import { test, expect } from '@playwright/test';

test('find Dad Joke home page', async ({ page, baseURL }) => {
  console.log('Test: Open Dad Joke website');
  console.log('Using Base URL: ' + baseURL);
  console.log('process.env.CI: ' + process.env.CI);
  console.log('process.env.TEST_ENVIRONMENT: ' + process.env.TEST_ENVIRONMENT);
  await page.goto('/');
  await expect(page).toHaveTitle(/Dad/);
});

test('find Dad Joke about page', async ({ page, baseURL }) => {
  console.log('Test: Find About page');
  console.log('Using Base URL: ' + baseURL);
  console.log('process.env.CI: ' + process.env.CI);
  console.log('process.env.TEST_ENVIRONMENT: ' + process.env.TEST_ENVIRONMENT);
  await page.goto('/');
  await page.getByRole('link', { name: 'about' }).click();
  await expect(page.getByRole('heading', { name: 'About' })).toBeVisible();
  // await expect(page.getByRole('heading', { name: 'Break the Dad-A-Base UI Test' })).toBeVisible();
});
