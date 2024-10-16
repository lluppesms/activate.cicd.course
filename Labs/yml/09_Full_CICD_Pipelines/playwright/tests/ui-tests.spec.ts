import { test, expect } from '@playwright/test';

test('find home page', async ({ page, baseURL }) => {
  console.log('Test: Open website');
  console.log('Using Base URL: ' + baseURL);
  console.log('process.env.CI: ' + process.env.CI);
  console.log('process.env.TEST_ENVIRONMENT: ' + process.env.TEST_ENVIRONMENT);
  await page.goto('/');
  await expect(page).toHaveTitle(/Dad/);
});

test('find search page', async ({ page, baseURL }) => {
  console.log('Test: Find Search page');
  console.log('Using Base URL: ' + baseURL);
  console.log('process.env.CI: ' + process.env.CI);
  console.log('process.env.TEST_ENVIRONMENT: ' + process.env.TEST_ENVIRONMENT);
  await page.goto('/');
  await page.getByRole('link', { name: 'Search' }).click();
  await expect(page.getByRole('heading', { name: 'Search' })).toBeVisible();
  // uncomment this to fail a test...
  // await expect(page.getByRole('heading', { name: 'Break Test' })).toBeVisible();
});
